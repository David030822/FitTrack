using Microsoft.EntityFrameworkCore;
using dotnet.Models;

namespace dotnet.Data;
public class AppDbContext : DbContext{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options){}
    public DbSet<User> Users { get; set; }
    public DbSet<Workout> Workouts { get; set; }
    public DbSet<WorkoutCategory> WorkoutCategories { get; set; }
    public DbSet<Calories> Calories { get; set; }
    public DbSet<WorkoutCalories> WorkoutCalories { get; set; }
    public DbSet<Steps> Steps { get; set; }
    public DbSet<Meal> Meal { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure Parent-Child Relationship
        modelBuilder.Entity<User>()
            .HasOne(u => u.Parent)
            .WithMany(p => p.Children)
            .HasForeignKey(u => u.ParentId)
            .OnDelete(DeleteBehavior.Restrict); // Prevent deletion of parent if children exist

        // Configure relationships
        // One-to-Many: User -> Workouts
        modelBuilder.Entity<Workout>()
            .HasOne(w => w.User)
            .WithMany(u => u.Workouts)
            .HasForeignKey(w => w.UserId)
            .OnDelete(DeleteBehavior.Cascade); // Delete workouts when user is deleted

        // One-to-Many: Category -> Workouts
        modelBuilder.Entity<Workout>()
            .HasOne(w => w.Category)
            .WithMany(c => c.Workouts)
            .HasForeignKey(w => w.CategoryId)
            .OnDelete(DeleteBehavior.Restrict); // Prevent category deletion if workouts exist

        // One-to-One: Workout -> WorkoutCalories
        modelBuilder.Entity<WorkoutCalories>()
                .HasKey(wc => wc.WorkoutId);

        modelBuilder.Entity<WorkoutCalories>()
            .HasOne(wc => wc.Workout)
            .WithOne(w => w.WorkoutCalories)
            .HasForeignKey<WorkoutCalories>(wc => wc.WorkoutId)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-One: Calories -> WorkoutCalories
        modelBuilder.Entity<WorkoutCalories>()
            .HasOne(wc => wc.Calories)
            .WithOne(c => c.WorkoutCalories)
            .HasForeignKey<WorkoutCalories>(wc => wc.CaloriesId)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-One: Steps -> Calories
        modelBuilder.Entity<Steps>()
            .HasOne(s => s.Calories)
            .WithOne(c => c.Steps)
            .HasForeignKey<Steps>(s => s.CaloriesId)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-Many: User -> Heatmap
        modelBuilder.Entity<Heatmap>()
            .HasOne(h => h.User)
            .WithMany(u => u.Heatmaps)
            .HasForeignKey(h => h.UserId)
            .OnDelete(DeleteBehavior.Cascade);  // Delete heatmaps when user is deleted

        // One-to-Many: Level -> Heatmap
        modelBuilder.Entity<Heatmap>()
            .HasOne(h => h.Level)
            .WithMany(l => l.Heatmaps)
            .HasForeignKey(h => h.LevelId)
            .OnDelete(DeleteBehavior.Restrict);  // Prevent level deletion if heatmaps exist

        // One-to-Many: User -> Meal
        modelBuilder.Entity<Meal>()
            .HasOne(m => m.User)
            .WithMany(u => u.Meals)
            .HasForeignKey(m => m.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-One: Meal -> Calories
        modelBuilder.Entity<Meal>()
            .HasOne(m => m.Calories)
            .WithOne(c => c.Meal)
            .HasForeignKey<Meal>(m => m.CaloriesID)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-Many: User -> Goals
        modelBuilder.Entity<Goal>()
            .HasOne(g => g.User)
            .WithMany(u => u.Goals)
            .HasForeignKey(g => g.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-Many: Goal -> GoalChecked
        modelBuilder.Entity<GoalChecked>()
                .HasKey(gc => gc.GoalId);

        modelBuilder.Entity<GoalChecked>()
            .HasOne(gc => gc.Goal)
            .WithMany(g => g.GoalChecked)
            .HasForeignKey(gc => gc.GoalId)
            .OnDelete(DeleteBehavior.Cascade);  // Delete goal checkeds when goal is deleted

        // One-to-Many: User -> Following
        modelBuilder.Entity<Following>()
            .HasOne(f => f.Follower)
            .WithMany(u => u.FollowingUsers)
            .HasForeignKey(f => f.FollowerId)
            .OnDelete(DeleteBehavior.Restrict);

        // One-to-Many: User -> Followers
        modelBuilder.Entity<Following>()
            .HasOne(f => f.Followed)
            .WithMany(u => u.Followers)
            .HasForeignKey(f => f.FollowedId)
            .OnDelete(DeleteBehavior.Restrict);

        // One-to-One: User -> AppDevices
        modelBuilder.Entity<User>()
            .HasOne(u => u.Devices)
            .WithOne(d => d.User)
            .HasForeignKey<User>(u => u.Udid)
            .OnDelete(DeleteBehavior.Restrict);  // Prevent device deletion if user exists

        // AppLogs
        modelBuilder.Entity<AppLogs>();
    }
}