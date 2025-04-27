using Microsoft.EntityFrameworkCore;
using dotnet.Models;
using dotnet.DAL;

namespace dotnet.Data;
public class AppDbContext : DbContext{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options){}
    public DbSet<UserDAL> Users { get; set; }
    public DbSet<WorkoutDAL> Workouts { get; set; }
    public DbSet<WorkoutCategoryDAL> WorkoutCategories { get; set; }
    public DbSet<CaloriesDAL> Calories { get; set; }
    public DbSet<WorkoutCaloriesDAL> WorkoutCalories { get; set; }
    public DbSet<StepsDAL> Steps { get; set; }
    public DbSet<MealDAL> Meal { get; set; }
    public DbSet<CaloriesGoalsDAL> CaloriesGoals { get; set; }

    public DbSet<HeatmapDAL> Heatmaps { get; set; }
    public DbSet<GoalDAL> Goals { get; set; }
    public DbSet<AppDevicesDAL> AppDevices { get; set; }
    public DbSet<FollowingDAL> Followings { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure Parent-Child Relationship
        modelBuilder.Entity<UserDAL>()
            .HasOne(u => u.Parent)
            .WithMany(p => p.Children)
            .HasForeignKey(u => u.ParentID)
            .OnDelete(DeleteBehavior.Restrict); // Prevent deletion of parent if children exist

        // Configure relationships
        // One-to-Many: User -> Workouts
        modelBuilder.Entity<WorkoutDAL>()
            .HasOne(w => w.User)
            .WithMany(u => u.Workouts)
            .HasForeignKey(w => w.UserID)
            .OnDelete(DeleteBehavior.Cascade); // Delete workouts when user is deleted

        // One-to-Many: Category -> Workouts
        modelBuilder.Entity<WorkoutDAL>()
            .HasOne(w => w.Category)
            .WithMany(c => c.Workouts)
            .HasForeignKey(w => w.CategoryID)
            .OnDelete(DeleteBehavior.Restrict); // Prevent category deletion if workouts exist

        // modelBuilder.Entity<WorkoutCaloriesDAL>()
        //     .HasKey(wc => new { wc.WorkoutID, wc.CaloriesID });  // Composite PK

        // Define relationships
        modelBuilder.Entity<WorkoutCaloriesDAL>()
            .HasOne(wc => wc.Workout)
            .WithOne(w => w.WorkoutCalories)
            .HasForeignKey<WorkoutCaloriesDAL>(wc => wc.WorkoutID)
            .OnDelete(DeleteBehavior.Cascade); // Delete WorkoutCalories if Workout is deleted

        // modelBuilder.Entity<WorkoutCaloriesDAL>()
        //     .HasOne(wc => wc.Calories)
        //     .WithOne(c => c.WorkoutCalories)
        //     .HasForeignKey<WorkoutCaloriesDAL>(wc => wc.CaloriesID)
        //     .OnDelete(DeleteBehavior.Cascade); // Delete WorkoutCalories if Calories entry is deleted

        modelBuilder.Entity<CaloriesDAL>()
            .HasOne(c => c.WorkoutCalories)
            .WithOne(wc => wc.Calories)
            .HasForeignKey<WorkoutCaloriesDAL>(wc => wc.CaloriesID)
            .IsRequired()
            .OnDelete(DeleteBehavior.Cascade);  // Delete Calories if WorkoutCalories is deleted

        // One-to-One: Steps -> Calories
        modelBuilder.Entity<StepsDAL>()
            .HasOne(s => s.Calories)
            .WithOne(c => c.Steps)
            .HasForeignKey<StepsDAL>(s => s.CaloriesID)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-Many: User -> Heatmap
        modelBuilder.Entity<HeatmapDAL>()
            .HasOne(h => h.User)
            .WithMany(u => u.Heatmaps)
            .HasForeignKey(h => h.UserID)
            .OnDelete(DeleteBehavior.Cascade);  // Delete heatmaps when user is deleted

        // One-to-Many: Level -> Heatmap
        modelBuilder.Entity<HeatmapDAL>()
            .HasOne(h => h.Level)
            .WithMany(l => l.Heatmaps)
            .HasForeignKey(h => h.LevelID)
            .OnDelete(DeleteBehavior.Restrict);  // Prevent level deletion if heatmaps exist

        // One-to-Many: User -> Meal
        modelBuilder.Entity<MealDAL>()
            .HasOne(m => m.User)
            .WithMany(u => u.Meals)
            .HasForeignKey(m => m.UserID)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-One: Meal -> Calories
        modelBuilder.Entity<MealDAL>()
            .HasOne(m => m.Calories)
            .WithOne(c => c.Meal)
            .HasForeignKey<MealDAL>(m => m.CaloriesID)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-Many: User -> Goals
        modelBuilder.Entity<GoalDAL>()
            .HasOne(g => g.User)
            .WithMany(u => u.Goals)
            .HasForeignKey(g => g.UserID)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-Many: Goal -> GoalChecked
        modelBuilder.Entity<GoalCheckedDAL>()
                .HasKey(gc => gc.GoalID);

        modelBuilder.Entity<GoalCheckedDAL>()
            .HasOne(gc => gc.Goal)
            .WithMany(g => g.GoalChecked)
            .HasForeignKey(gc => gc.GoalID)
            .OnDelete(DeleteBehavior.Cascade);  // Delete goal checkeds when goal is deleted

        modelBuilder.Entity<FollowingDAL>()
            .HasOne(f => f.Follower)
            .WithMany(u => u.FollowingUsers)
            .HasForeignKey(f => f.FollowerID)
            .OnDelete(DeleteBehavior.Restrict);     // Prevent user deletion if followers exist

        modelBuilder.Entity<FollowingDAL>()
            .HasOne(f => f.Followed)
            .WithMany(u => u.Followers)
            .HasForeignKey(f => f.FollowedID)
            .OnDelete(DeleteBehavior.Restrict);     // Prevent user deletion if following users exist

        // One-to-One: User -> AppDevices
        // modelBuilder.Entity<UserDAL>()
        //     .HasOne(u => u.AppDevices)
        //     .WithOne(d => d.User)
        //     .HasForeignKey<UserDAL>(u => u.UDID)
        //     .OnDelete(DeleteBehavior.Restrict);  // Prevent device deletion if user exists

        // AppLogs
        modelBuilder.Entity<AppLogs>();

        // One-to-One: User -> CaloriesGoals
        modelBuilder.Entity<CaloriesGoalsDAL>()
            .HasOne(c => c.User)
            .WithOne(u => u.CaloriesGoals)
            .HasForeignKey<CaloriesGoalsDAL>(c => c.UserID)
            .OnDelete(DeleteBehavior.Cascade);  // Delete CaloriesGoals if User is deleted
    }
}