namespace dotnet.DTOs
{
    public class PlannedMealDto
    {
        public int PlannedMealID { get; set; }
        public string MealType { get; set; } // Breakfast, etc.
        public string Name { get; set; }
        public string? Description { get; set; }
        public int? Calories { get; set; }
        public TimeOnly Time { get; set; }
    }
}
