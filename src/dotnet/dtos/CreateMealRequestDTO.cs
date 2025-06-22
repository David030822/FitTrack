public class CreateMealRequestDto
{
    public string MealType { get; set; }
    public string Name { get; set; }
    public string? Description { get; set; }
    public int? Calories { get; set; }
    public TimeOnly Time { get; set; }
    public int MealScheduleDayID { get; set; }
}
