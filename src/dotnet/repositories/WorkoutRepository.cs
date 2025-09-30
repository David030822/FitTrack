using dotnet.DAL;
using dotnet.Data;
using dotnet.DTOs;
using dotnet.Helper;
using dotnet.Models;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Repositories
{
    public class WorkoutRepository : IWorkoutRepository
    {
        private readonly AppDbContext _context;

        public WorkoutRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Workout>> GetAllWorkoutsAsync()
        {
            var workouts = await _context.Workouts.ToListAsync();
            return workouts.Select(WorkoutConverter.FromWorkoutDALToWorkout);
        }

        public async Task<Workout?> GetWorkoutByIdAsync(int id)
        {
            var workoutDAL = await _context.Workouts.FindAsync(id);
            return workoutDAL == null ? null : WorkoutConverter.FromWorkoutDALToWorkout(workoutDAL);
        }

        public async Task<Workout> AddWorkoutAsync(Workout workout)
        {
            // Check if user exists
            var userExists = await _context.Users.AnyAsync(u => u.UserID == workout.UserId);
            if (!userExists)
            {
                throw new Exception($"User with ID {workout.UserId} does not exist.");
            }

            // Check if category exists
            var categoryExists = await _context.WorkoutCategories.AnyAsync(c => c.CategoryID == workout.CategoryId);
            if (!categoryExists)
            {
                throw new Exception($"Category with ID {workout.CategoryId} does not exist.");
            }

            // Convert Workout to DAL entity
            var workoutDAL = WorkoutConverter.FromWorkoutToWorkoutDAL(workout);
            
            // Ensure DateTime fields are in UTC before saving
            workoutDAL.StartDate = DateTime.UtcNow;

            // Insert Workout first
            _context.Workouts.Add(workoutDAL);
            await _context.SaveChangesAsync(); // Save first to generate WorkoutID
            Console.WriteLine("DAL ID:" + workoutDAL.WorkoutID);

            // Now insert Calories, since WorkoutID exists
            var caloriesDAL = new CaloriesDAL
            { 
                Amount = 0,
                DateTime = workoutDAL.StartDate,
            };
            _context.Calories.Add(caloriesDAL);
            await _context.SaveChangesAsync(); // Save to get CaloriesID

            // Create the link between Workout and Calories
            var workoutCaloriesDAL = new WorkoutCaloriesDAL
            {
                WorkoutID = workoutDAL.WorkoutID,
                CaloriesID = caloriesDAL.CaloriesID
            };
            _context.WorkoutCalories.Add(workoutCaloriesDAL);
            await _context.SaveChangesAsync();

            var createdWorkout = await _context.Workouts.FindAsync(workoutDAL.WorkoutID);
            var returnedWorkout = WorkoutConverter.FromWorkoutDALToWorkout(createdWorkout);
            Console.WriteLine("Returned Workout ID: " + returnedWorkout.Id);
            return returnedWorkout;
        }

        public async Task UpdateWorkoutAsync(Workout workout)
        {
            var existingWorkout = await _context.Workouts.FindAsync(workout.Id);
            if (existingWorkout != null)
            {
                existingWorkout.Distance = workout.Distance;
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteWorkoutAsync(int id)
        {
            var workoutDAL = await _context.Workouts.FindAsync(id);
            if (workoutDAL != null)
            {
                // Remove related WorkoutCalories and maybe Calories entry if you want
                var workoutCalories = await _context.WorkoutCalories
                    .FirstOrDefaultAsync(wc => wc.WorkoutID == id);

                if (workoutCalories != null)
                {
                    var calories = await _context.Calories.FindAsync(workoutCalories.CaloriesID);
                    if (calories != null)
                        _context.Calories.Remove(calories);

                    // _context.WorkoutCalories.Remove(workoutCalories);
                }
                
                _context.Workouts.Remove(workoutDAL);
                await _context.SaveChangesAsync();
            }
        }

        public async Task UpdateWorkoutCaloriesAsync(int workoutId, double newCalories, double distance)
        {
            var workoutCalories = await _context.WorkoutCalories
                .FirstOrDefaultAsync(wc => wc.WorkoutID == workoutId);

            if (workoutCalories == null)
            {
                Console.WriteLine("❌ No WorkoutCalories entry found.");
                throw new Exception($"No calorie entry found for workout ID {workoutId}");
            }

            var caloriesEntry = await _context.Calories.FindAsync(workoutCalories.CaloriesID);
            if (caloriesEntry == null)
                throw new Exception($"Calories entry {workoutCalories.CaloriesID} not found.");

            // ✅ Update Calories Amount
            caloriesEntry.Amount = newCalories;

            // ✅ Also update the workout's EndDate
            var workout = await _context.Workouts.FindAsync(workoutId);
            if (workout == null)
                throw new Exception($"Workout {workoutId} not found.");

            workout.EndDate = DateTime.UtcNow; // Mark as finished

            // ✅ Update Distance
            workout.Distance = distance;

            Console.WriteLine($"Updating workout {workoutId}: calories={newCalories}, distance={distance}");

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                Console.WriteLine("🔥 EF SaveChanges failed: " + ex.Message);
                if (ex.InnerException != null)
                {
                    Console.WriteLine("👉 Inner Exception: " + ex.InnerException.Message);
                }
                throw;
            }
        }

        public async Task<Workout?> GetOngoingWorkoutForUser(int userId)
        {
            var dalWorkout = await _context.Workouts
                .Where(w => w.UserID == userId && w.EndDate == null)
                .OrderByDescending(w => w.StartDate)
                .FirstOrDefaultAsync();

            if (dalWorkout == null)
                return null;

            return WorkoutConverter.FromWorkoutDALToWorkout(dalWorkout);
        }

        public async Task<IEnumerable<Workout>> GetWorkoutsByUserIdAsync(int userId)
        {
            var workouts = await _context.Workouts
                .Include(w => w.Category)
                .Where(w => w.UserID == userId)
                .ToListAsync();

            return workouts.Select(WorkoutConverter.FromWorkoutDALToWorkout);
        }

        public async Task<IEnumerable<WorkoutDTO>> GetWorkoutDTOsForUserAsync(int userId)
        {
            var workouts = await _context.Workouts
                .Include(w => w.Category)
                .Include(w => w.WorkoutCalories)
                    .ThenInclude(wc => wc.Calories)
                .Where(w => w.UserID == userId)
                .ToListAsync();

            foreach (var w in workouts)
            {
                Console.WriteLine($"👉Repo WorkoutID: {w.WorkoutID}, Category: {(w.Category == null ? "NULL" : w.Category.Name)}, Calories: {(w.WorkoutCalories == null ? "NULL" : w.WorkoutCalories.Calories.Amount.ToString())}, Date: {w.StartDate} - {w.EndDate}");
            }

            return workouts.Select(w => new WorkoutDTO
            {
                Id = w.WorkoutID,
                Distance = w.Distance,
                StartDate = w.StartDate.ToLocalTime(), // StartDate is NOT nullable, so normal ToLocalTime
                EndDate = w.EndDate.ToLocalTimeSafe(),
                Category = w.Category?.Name ?? "Unknown",
                Calories = Math.Round(w.WorkoutCalories?.Calories?.Amount ?? 0, 2),  // Two decimals,
                Duration = w.EndDate.HasValue
                    ? (w.EndDate.Value - w.StartDate).ToString(@"hh\:mm\:ss")
                    : null,

                AvgPace = (w.EndDate.HasValue && w.Distance > 0)
                    ? $"{(w.EndDate.Value - w.StartDate).TotalMinutes / w.Distance:0.00} min/km"
                    : null
            }).ToList();
        }
    }
}