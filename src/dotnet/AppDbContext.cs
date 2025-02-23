using Microsoft.EntityFrameworkCore;
using dotnet.Models;

namespace dotnet;
public class AppDbContext : DbContext{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options){}
    public DbSet<User> Users { get; set; }
}
