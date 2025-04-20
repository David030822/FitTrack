using dotnet.DTOs;
using dotnet.Models;

namespace dotnet.Services
{
    public interface IWorkoutService
    {
        Task<IEnumerable<Workout>> GetAllWorkoutsAsync();
        Task<Workout?> GetWorkoutByIdAsync(int id);
        Task<Workout> AddWorkoutAsync(Workout workout);
        Task UpdateWorkoutAsync(Workout workout);
        Task DeleteWorkoutAsync(int id);
        Task UpdateWorkoutCaloriesAsync(int workoutId, double newCalories, double distance);
        Task<Workout?> GetOngoingWorkoutForUser(int userId);
        Task<IEnumerable<Workout>> GetWorkoutsByUserIdAsync(int userId);
        Task<IEnumerable<WorkoutDTO>> GetWorkoutDTOsForUserAsync(int userId);
    }
}