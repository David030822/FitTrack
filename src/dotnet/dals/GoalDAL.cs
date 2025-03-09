using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("Goals")]
    public class GoalDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int GoalID { get; set; }
        [Required]
        public int UserID { get; set; }
        [ForeignKey("UserID")]
        public UserDAL User { get; set; }
        [Required]
        public string Text { get; set; }
        [Required]
        public bool IsCompleted { get; set; }
        public ICollection<GoalCheckedDAL> GoalChecked { get; set; }
    }
}