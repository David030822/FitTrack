using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("MealLog")]
    public class MealLog
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int MealId { get; set; }

        [ForeignKey("MealId")]
        public PlannedMealDAL Meal { get; set; }

        [Required]
        public DateTime Date { get; set; }

        [Required]
        public MealStatus Status { get; set; }
    }

    public enum MealStatus
    {
        Completed = 0,
        Skipped = 1
    }
}