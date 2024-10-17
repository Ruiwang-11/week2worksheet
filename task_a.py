

days_of_week= {
            'monday':1,
            'tuesday':2,
            'wednesday':3,
            'thursday':4,
            'friday':5,
            'saturday':6,
            'sunday':7
}
user_input=input(f"Enter a day of the week {"Monday", "Tuesday", }:").strip().lower()
if user_input in days_of_week:  
    day_number=days_of_week[user_input]
    print(f" { user_input.capitalize()} is day {day_number}") 
else: 
    print("Please enter a valid day")                            
