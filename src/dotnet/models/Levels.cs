using dotnet.DAL;

namespace dotnet.Models
{
    public class Levels
    {
        public int Id { get; set; }
        public string Color { get; set; }
        public ICollection<HeatmapDAL> Heatmaps { get; set; }
    }
}