using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("Meals")]
    public class MealDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int MealID { get; set; }
        [Required]
        public int UserID { get; set; }
        [ForeignKey("UserID")]
        public UserDAL User { get; set; }
        [Required]
        public int CaloriesID { get; set; }
        [ForeignKey("CaloriesID")]
        public CaloriesDAL Calories { get; set; }
        [Required]
        public string Name { get; set; }
        public string? Description { get; set; }
    }
}