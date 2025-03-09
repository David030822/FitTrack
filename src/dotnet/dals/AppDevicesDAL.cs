using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("AppDevices")]
    public class AppDevicesDAL
    {
        [Key]
        public int UDID { get; set; }
        [Required]
        public DateTime Registered { get; set; }
        public double Used { get; set; }
        public DateTime LastUsed { get; set; }
        // public UserDAL User { get; set; }
    }
}