def bad(cursor, user_id):
    cursor.execute("SELECT * FROM users WHERE id = " + user_id)   # should flag
    cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")   # should flag

def good(cursor, user_id):
    cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))  # should not flag