using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("Following")]
    public class FollowingDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int FollowingID { get; set; }
        [Required]
        public int FollowerID { get; set; }
        [ForeignKey("FollowerID")]
        [InverseProperty("FollowingUsers")]
        public UserDAL Follower { get; set; }
        [Required]
        public int FollowedID { get; set; }
        [ForeignKey("FollowedID")]
        [InverseProperty("Followers")]
        public UserDAL Followed { get; set; }
    }
}