namespace dotnet.DTOs
{
    public class MealScheduleDayDto
    {
        public int MealScheduleDayID { get; set; }
        public int DayOfWeek { get; set; } // 0 = Monday
        public bool IsCheatDay { get; set; }
        public List<PlannedMealDto> PlannedMeals { get; set; }
    }
}
