using dotnet.DAL;
using dotnet.Data;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Repositories
{
    public class PlannedWorkoutRepository : IPlannedWorkoutRepository
    {
        private readonly AppDbContext _context;

        public PlannedWorkoutRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<PlannedWorkoutDAL>> GetWorkoutsForDayAsync(int dayId)
        {
            return await _context.PlannedWorkouts
                .Where(w => w.WorkoutScheduleDayID == dayId)
                .ToListAsync();
        }

        public async Task<PlannedWorkoutDAL> AddWorkoutToDayAsync(PlannedWorkoutDAL workout)
        {
            _context.PlannedWorkouts.Add(workout);
            await _context.SaveChangesAsync();
            return workout;
        }

        public Task UpdateWorkoutAsync(PlannedWorkoutDAL workout)
        {
            _context.PlannedWorkouts.Update(workout);
            return Task.CompletedTask;
        }

        public async Task DeleteWorkoutAsync(int workoutId)
        {
            var workout = await _context.PlannedWorkouts.FindAsync(workoutId);
            if (workout != null)
            {
                _context.PlannedWorkouts.Remove(workout);
                await _context.SaveChangesAsync();
            }
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }

        public async Task<PlannedWorkoutDAL?> GetWorkoutByIdAsync(int id)
        {
            return await _context.PlannedWorkouts.FindAsync(id);
        }
    }
}