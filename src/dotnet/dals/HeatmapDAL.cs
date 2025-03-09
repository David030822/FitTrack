using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using dotnet.Models;

namespace dotnet.DAL
{
    [Table("Heatmap")]
    public class HeatmapDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int HeatmapID { get; set; }
        [Required]
        public int UserID { get; set; }
        [ForeignKey("UserID")]
        public UserDAL User { get; set; }
        [Required]
        public int LevelID { get; set; }
        [ForeignKey("LevelID")]
        public Levels Level { get; set; }
        [Required]
        public DateOnly Date { get; set; }
    }
}