namespace dotnet.Models;

public class User
{
    public int Id { get; set; }
    public int? Udid { get; set; }           // Unique Device Identifier
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Email { get; set; }
    public string? PhoneNum { get; set; }
    public int? Age { get; set; }
    public string? Gender { get; set; }
    public double? Height { get; set; }
    public double? Weight { get; set; }
    public double? BodyFat { get; set; }
    public string? Goal { get; set; }
    public string Username { get; set; }
    public byte[] PasswordHash { get; set; }
    public byte[] PasswordSalt { get; set; }
    public string ?ProfilePhotoPath { get; set; }
    public int? ParentId { get; set; } // Nullable: Not all users have parents
}