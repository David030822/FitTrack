using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("CaloriesGoals")]
    public class CaloriesGoalsDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int CaloriesGoalsID { get; set; }
        public double? IntakeGoal { get; set; }
        public double? BurnGoal { get; set; }
        public double? OverallGoal { get; set; }
        public int? IntakeStreak { get; set; }
        public int? BurnStreak { get; set; }
        public DateTime? LastIntakeStreakUpdate { get; set; }
        public DateTime? LastBurnStreakUpdate { get; set; }

        [Required]
        public int UserID { get; set; }
        // Navigation Properties
        [ForeignKey("UserID")]
        public UserDAL User { get; set; }  // Relationship to UserDAL
    }
}