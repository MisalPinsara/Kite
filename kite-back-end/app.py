from flask import Flask, jsonify, request
from flask_cors import CORS
import json
import os

app = Flask(__name__)

CORS(
    app,
    resources={r"/*": {"origins": "*"}},
    allow_headers=["Content-Type", "ngrok-skip-browser-warning"]
)

def load_data():
    try:
        with open("data.json", "r") as file:
            return json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        return {"users": [], "events": [], "myEvents": [], "reviews": []}

def save_data(data):
    with open("data.json", "w") as file:
        json.dump(data, file, indent=4)

@app.route('/users', methods=['GET'])
def get_all_users():
    data = load_data()
    return jsonify(data.get("users", []))

@app.route('/users/login/<string:username>', methods=['GET'])
def get_user(username):
    data = load_data()
    user = next((u for u in data['users'] if u["username"] == username), None)
    if user:
        response = jsonify(user)
        print("Returning user JSON:", response.get_data(as_text=True))
        return response, 200
    else:
        response = jsonify({"error": "User not found"})
        print("Returning error JSON:", response.get_data(as_text=True))
        return response, 404

@app.route('/users/register', methods=['POST'])
def post_user():
    data = load_data()
    new_user = request.json
    existing_ids = [u["id"] for u in data["users"]]
    new_user["id"] = max(existing_ids + [0]) + 1
    
    data["users"].append(new_user)
    save_data(data)
    return jsonify(new_user), 201

@app.route('/users/update/<int:user_id>', methods=['PUT'])
def put_user(user_id):
    data = load_data()
    updated_info = request.json
    for user in data['users']:
        if user["id"] == user_id:
            user.update(updated_info)
            save_data(data)
            return jsonify(user)
    return jsonify({"error": "User not found"}), 404

@app.route('/users/delete/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    data = load_data()
    data["users"] = [u for u in data["users"] if u["id"] != user_id]
    save_data(data)
    return jsonify({"message": "User deleted"}), 200

@app.route('/events', methods=['GET'])
def get_all_events():
    data = load_data()
    return jsonify(data.get("events", []))

@app.route('/events/<int:event_id>', methods=['GET'])
def get_event(event_id):
    data = load_data()
    event = next((e for e in data['events'] if e["Id"] == event_id), None)
    return jsonify(event) if event else (jsonify({"error": "Event not found"}), 404)

@app.route('/events/<int:event_id>', methods=['PUT'])
def put_event(event_id):
    data = load_data()
    updated_info = request.json
    for event in data['events']:
        if event["Id"] == event_id:
            event.update(updated_info)
            save_data(data)
            return jsonify(event)
    return jsonify({"error": "Event not found"}), 404

@app.route('/reviews', methods=['GET'])
def get_reviews():
    data = load_data()
    return jsonify(data.get("reviews", []))

@app.route('/reviews', methods=['POST'])
def post_review():
    data = load_data()
    new_review = request.json
    if not new_review:
        return jsonify({"error": "No data provided"}), 400
    
    data["reviews"].append(new_review)
    save_data(data)
    return jsonify(new_review), 201

@app.route('/myEvents/<int:user_id>', methods=['GET'])
def get_my_events(user_id):
    data = load_data()
    user_myEvents = [m for m in data["myEvents"] if m["UserId"] == user_id]
    
    my_full_events = []
    for m in user_myEvents:
        for e in data["events"]:
            if e["Id"] == m["EventId"]:
                event_copy = dict(e)
                event_copy["registeredMail"] = m.get("registeredMail", "")
                my_full_events.append(event_copy)
                break
    return jsonify(my_full_events)

@app.route('/myEvents', methods=['POST'])
def post_my_event():
    data = load_data()
    new_link = request.json
    if not new_link or "UserId" not in new_link or "EventId" not in new_link or "registeredMail" not in new_link:
        return jsonify({"error": "Invalid data"}), 400
    
    # Check if already registered
    for m in data["myEvents"]:
        if m["UserId"] == new_link["UserId"] and m["EventId"] == new_link["EventId"]:
            return jsonify({"error": "Already registered"}), 400
            
    existing_ids = [m.get("Id", 0) for m in data["myEvents"]]
    new_link["Id"] = max(existing_ids + [0]) + 1
    data["myEvents"].append(new_link)
    
    # Decrease seatsLeft
    for event in data["events"]:
        if event["Id"] == new_link["EventId"]:
            if event.get("seatsLeft", 0) > 0:
                event["seatsLeft"] -= 1
            break
            
    save_data(data)
    return jsonify(new_link), 201

@app.route('/myEvents/<int:user_id>/<int:event_id>', methods=['PUT'])
def update_my_event(user_id, event_id):
    data = load_data()
    updated_info = request.json
    for m in data["myEvents"]:
        if m["UserId"] == user_id and m["EventId"] == event_id:
            m["registeredMail"] = updated_info.get("registeredMail", m.get("registeredMail"))
            save_data(data)
            return jsonify(m), 200
    return jsonify({"error": "Event registration not found"}), 404

@app.route('/myEvents/<int:user_id>/<int:event_id>', methods=['DELETE'])
def delete_my_event(user_id, event_id):
    data = load_data()
    original_len = len(data["myEvents"])
    data["myEvents"] = [m for m in data["myEvents"] if not (m["UserId"] == user_id and m["EventId"] == event_id)]
    
    # Increase seatsLeft if an event was actually removed
    if len(data["myEvents"]) < original_len:
        for event in data["events"]:
            if event["Id"] == event_id:
                event["seatsLeft"] += 1
                break
                
    save_data(data)
    return jsonify({"message": "Event removed from your list"}), 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)
