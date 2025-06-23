using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("PlannedWorkouts")]
    public class PlannedWorkoutDAL
    {
        [Key]
        public int PlannedWorkoutID { get; set; }

        [Required]
        public int WorkoutScheduleDayID { get; set; }

        [ForeignKey("WorkoutScheduleDayID")]
        public WorkoutScheduleDayDAL WorkoutScheduleDay { get; set; }

        [Required]
        public string Name { get; set; }

        public string? Description { get; set; }

        [Required]
        public string TargetMuscle { get; set; }

        public int Sets { get; set; }

        public int Reps { get; set; }
    }
}