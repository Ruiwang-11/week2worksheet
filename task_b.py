
grade=input("What is your grade(enter between 0-100)")
try:
    grade=float(grade)
    if grade < 0 or grade > 100:
        print("Error: Grades must be between 0 and 100")
    else:  
        if 80<=grade<=100:
            print(f"Your grade is: A")
        elif 60<= grade<= 79:
            print(f"Your grade is: B")
        elif 50<= grade<= 59:
            print(f"Your grade is: C")
        elif 39<= grade<= 40:
            print(f"Your grade is: D")
        elif 0<= grade<= 39:
            print(f"Your grade is: F")
        else:
            print("Error: Please enter a number")
except: 
    print("Error: Please enter a number")    