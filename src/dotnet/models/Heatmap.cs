namespace dotnet.Models
{
    public class Heatmap
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int LevelId { get; set; }
        public DateOnly Date { get; set; }
    }
}