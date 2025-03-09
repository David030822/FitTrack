namespace dotnet.Models
{
    public class GoalChecked
    {
        public int GoalID { get; set; }
        public Goal Goal { get; set; }
        public DateOnly Date { get; set; }
    }
}