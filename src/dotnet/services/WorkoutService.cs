using dotnet.DTOs;
using dotnet.Models;
using dotnet.Repositories;

namespace dotnet.Services
{
    public class WorkoutService : IWorkoutService
    {
        private readonly IWorkoutRepository _workoutRepository;

        public WorkoutService(IWorkoutRepository workoutRepository)
        {
            _workoutRepository = workoutRepository;
        }

        public async Task<IEnumerable<Workout>> GetAllWorkoutsAsync()
        {
            return await _workoutRepository.GetAllWorkoutsAsync();
        }

        public async Task<Workout?> GetWorkoutByIdAsync(int id)
        {
            return await _workoutRepository.GetWorkoutByIdAsync(id);
        }

        public async Task<Workout> AddWorkoutAsync(Workout workout)
        {
            var savedWorkout = await _workoutRepository.AddWorkoutAsync(workout);
            Console.WriteLine("Workout service: " + savedWorkout.Id);
            return savedWorkout; // ✅ Return the updated one
        }

        public async Task UpdateWorkoutAsync(Workout workout)
        {
            await _workoutRepository.UpdateWorkoutAsync(workout);
        }

        public async Task DeleteWorkoutAsync(int id)
        {
            await _workoutRepository.DeleteWorkoutAsync(id);
        }

        public async Task UpdateWorkoutCaloriesAsync(int workoutId, double newCalories, double distance)
        {
            await _workoutRepository.UpdateWorkoutCaloriesAsync(workoutId, newCalories, distance);
        }

        public async Task<Workout?> GetOngoingWorkoutForUser(int userId)
        {
            return await _workoutRepository.GetOngoingWorkoutForUser(userId);
        }

        public async Task<IEnumerable<Workout>> GetWorkoutsByUserIdAsync(int userId)
        {
            return await _workoutRepository.GetWorkoutsByUserIdAsync(userId);
        }

        public async Task<IEnumerable<WorkoutDTO>> GetWorkoutDTOsForUserAsync(int userId)
        {
            return await _workoutRepository.GetWorkoutDTOsForUserAsync(userId);
        }
    }
}
