namespace dotnet.DTOs
{
    public class MealScheduleDto
    {
        public int MealScheduleID { get; set; }
        public int UserID { get; set; }
        public string? Title { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsActive { get; set; }
        public List<MealScheduleDayDto> Days { get; set; }
    }
}
