using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using dotnet.DAL;

namespace dotnet.Models;

public class UserAdviceDTO
{
    public Guid Id { get; set; }
    public string Advice { get; set; }
    public string Title { get; set; }
    public DateTime CreatedAt { get; set; }
}