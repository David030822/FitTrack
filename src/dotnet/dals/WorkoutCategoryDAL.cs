using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("WorkoutCategories")]
    public class WorkoutCategoryDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int CategoryID { get; set; }
        [Required]
        [MaxLength(50)]
        public string Name { get; set; }
        public string? Icon { get; set; }

        // Navigation property: A category has multiple workouts
        public ICollection<WorkoutDAL> Workouts = new List<WorkoutDAL>();
    }
}