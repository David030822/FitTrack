namespace dotnet.DTOs
{
    public class CaloriesGoalsDTO
    {
        public int CaloriesGoalsID { get; set; }
        public double? IntakeGoal { get; set; }
        public double? BurnGoal { get; set; }
        public double? OverallGoal { get; set; }
        public int? IntakeStreak { get; set; }
        public int? BurnStreak { get; set; }
    }
}