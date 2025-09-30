using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using dotnet.DAL;

namespace dotnet.Models;

public class UserAdvice
{
    [Key]
    public Guid Id { get; set; }
    [Required]
    public int UserId { get; set; }
    [Required]
    public string Prompt { get; set; }
    [Required]
    public string Advice { get; set; }
    [Required]
    public string Title { get; set; }
    [Required]
    public DateTime CreatedAt { get; set; }
    [ForeignKey("UserId")]
    public UserDAL User { get; set; }
}