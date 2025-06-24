public class MealPlanRequestDTO
{
    public int UserId { get; set; }              // Who the advice is for
    public string UserInput { get; set; } = "";  // Optional question or input
    public string MealType { get; set; } = "";   // Optional meal type
    public int NumberOfMeals { get; set; } = 0;  // Optional number of meals
    public string DietType { get; set; } = "";   // Optional diet type
    public int NumberOfDays { get; set; } = 0;  // Optional number of days
    public int Calories { get; set; } = 0;       // Optional calories
}
