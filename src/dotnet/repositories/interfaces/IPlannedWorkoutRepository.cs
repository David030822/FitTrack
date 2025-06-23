using dotnet.DAL;

namespace dotnet.Repositories
{
    public interface IPlannedWorkoutRepository
    {
        Task<List<PlannedWorkoutDAL>> GetWorkoutsForDayAsync(int dayId);
        Task<PlannedWorkoutDAL> AddWorkoutToDayAsync(PlannedWorkoutDAL workout);
        Task UpdateWorkoutAsync(PlannedWorkoutDAL workout);
        Task DeleteWorkoutAsync(int workoutId);
        Task SaveChangesAsync();
        Task<PlannedWorkoutDAL> GetWorkoutByIdAsync(int id);
    }
}