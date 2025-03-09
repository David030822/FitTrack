using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("Steps")]
    public class StepsDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int StepsID { get; set; }
        [Required]
        public int StepsCount { get; set; }
        [Required]
        public DateTime Date { get; set; }
        [Required]
        public int CaloriesID { get; set; }
        [ForeignKey("CaloriesID")]
        public CaloriesDAL Calories { get; set; }
    }
}