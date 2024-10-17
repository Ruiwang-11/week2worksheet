
password = input("Please enter your password: ")
if len(password) >= 8 and any(char.isalpha() for char in password) and any(char.isdigit() for char in password):
    print("Your password is valid")
else:
    print("Your password must contain at least 8 characters, and a mix of letters and numbers")