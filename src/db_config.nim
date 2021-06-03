import db_sqlite
import md5


proc createUserTable*() =
    #[
    Create Table Procedure
    ]#
    let db = open("users.db", "", "", "")

    # Create Table
    try:
        db.exec(
            sql"""CREATE TABLE Users(
            UserID INTEGER PRIMARY KEY AUTOINCREMENT,
            Username TEXT NOT NULL,
            Email TEXT,
            Password TEXT NOT NULL
            )"""
        )
        echo "Table \'Users\' Created Successfully!"
    except DbError as err:
        echo "This table is available [ " & err.msg & " ]"
    
    finally:
        db.close()

proc createProfileTable*() = 
    let db = open("users.db", "", "", "")

    # Create Table
    try:
        db.exec(
            sql"""CREATE TABLE Profile(
            ProfileID INTEGER PRIMARY KEY AUTOINCREMENT,
            Firstname TEXT,
            Lastname TEXT,
            Age INTEGER,
            Bio TEXT,
            Date_joined TEXT,
            
            UserID INTEGER,
            CONSTRAINT fk_users
            FOREIGN KEY (UserID)
            REFERENCES users(UserID)
            )"""
        )
        echo "Table \'Profile\' Created Successfully!"

    except DbError as err:
        echo "This table is available [ " & err.msg & " ]"
    
    finally:
        db.close()

proc insertUser*(username:string, email:string, password:string) =
    let db = open("users.db", "", "", "")

    try:
        #let checkCurrentUserNme = db.getValue(sql"SELECT Username from ")
        db.exec(sql"BEGIN")
        db.exec(
            sql""" INSERT INTO Users (Username, Email, Password)
            VALUES (?, ?, ?) """, username, email, toMD5(password)
        )
        db.exec(sql"COMMIT")
        echo "User inserted successfully"

    except DbError as err:
        echo "An error occurred [ " & err.msg & " ]"

    finally:
        db.close()

proc insertProfile*(first_name:string, last_name:string, age:int, bio: string, date_joined:string, user_id:int) =
    let db = open("users.db", "", "", "")
    
    try:
        let checkProfileUniqueness = db.tryExec(sql "SELECT ProfileID FROM Profile WHERE UserID=?", user_id)

        if checkProfileUniqueness:
            echo "This User has Profile already!"
        else:
            db.exec(sql"BEGIN")
            db.exec(
                sql""" INSERT INTO Profile (Firstname, Lastname, Age, Bio, Date_joined, UserID)
                VALUES (?, ?, ?, ?, ?, ?)""", first_name, last_name, age, bio, date_joined, user_id
            )
            db.exec(sql"COMMIT")
            echo "New profile inserted for user with id: " & $user_id
            
    except DbError as err:
        echo "This Profile is available [ " & err.msg & " ]"

    finally:
        db.close()

proc deleteFromUser*(user_id: int) =
    let db = open("users.db", "", "", "")

    try:
        db.exec(sql"BEGIN")
        db.exec(
            sql"DELETE FROM Users WHERE UserID=?", user_id)
        db.exec(sql"COMMIT")
        echo "User with id: " & $user_id & " deleted!"

    except DbError as err:
        echo "An error occurred [ " & err.msg & " ]"

    finally:
        db.close()

proc deleteFormProfile*(profile_id: int) = 
    let db = open("users.db", "", "", "")

    try:
        db.exec(sql"BEGIN")
        db.exec(
            sql"DELETE FROM Profile WHERE ProfileID=?", profile_id)
        db.exec(sql"COMMIT")
        echo "Profile with id: " & $profile_id & " deleted!"

    except DbError as err:
        echo "An error occurred [ " & err.msg & " ]"

    finally:
        db.close()

proc updateUser*(first_name:string, last_name:string, user_id:int) = 
    let db = open("users.db", "", "", "")

    try:
        db.exec(sql"BEGIN")
        db.exec(
            sql"UPDATE User SET Username=?, Email=? WHERE ProfileID=?", first_name, last_name, user_id)
        db.exec(sql"COMMIT")
        echo "User with id: " & $user_id & " updated!"

    except DbError as err:
        echo "An error occurred [ " & err.msg & " ]"

    finally:
        db.close()






proc selectFromUser*() =
    let db = open("users.db", "", "", "")
    
    for item in db.getAllRows(sql"SELECT * FROM Users"):
        echo "UserID: " & item[0]
        echo "Username: " & item[1]
        echo "Email: " & item[2]
        echo "Password: " & item[3]
        echo "|---------------------|"
    db.close()

proc selectFromProfile*() =
    let db = open("users.db", "", "", "")
    
    for item in db.getAllRows(sql"SELECT * FROM Profile"):
        echo "ProfileId: " & item[0]
        echo "UserId: " & item[6]
        echo "Firstname: " & item[1]
        echo "Lastname: " & item[2]
        echo "Age: " & item[3]
        echo "Date-joined: " & item[5]
        echo "Bio: " & item[4]
        echo "|---------------------|"
    db.close()

proc a*(id: int) = 
    let db = open("users.db", "", "", "")
    let checkUser = db.tryExec(sql"SELECT Username FROM Users WHERE UserID=?", id)

    if checkUser:
        echo "This user already exists"
    else:
        echo "Wow new User!"

    db.close()