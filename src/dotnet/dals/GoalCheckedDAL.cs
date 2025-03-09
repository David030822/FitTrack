using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("GoalChecked")]
    public class GoalCheckedDAL
    {
        [Key]
        public int GoalID { get; set; }
        public GoalDAL Goal { get; set; }
        [Required]
        public DateOnly Date { get; set; }
    }
}