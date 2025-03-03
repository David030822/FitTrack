namespace dotnet.Models
{
    public class Levels
    {
        public int Id { get; set; }
        public string Color { get; set; }
        public ICollection<Heatmap> Heatmaps { get; set; }
    }
}