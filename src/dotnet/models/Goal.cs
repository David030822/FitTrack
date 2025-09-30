namespace dotnet.Models
{
    public class Goal
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Text { get; set; }
        public bool IsCompleted { get; set; }
    }
}