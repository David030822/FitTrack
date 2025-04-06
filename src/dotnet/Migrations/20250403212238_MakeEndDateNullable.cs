using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class MakeEndDateNullable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Calories_Meals_MealID",
                table: "Calories");

            migrationBuilder.DropForeignKey(
                name: "FK_Calories_Steps_StepsID",
                table: "Calories");

            migrationBuilder.DropForeignKey(
                name: "FK_Calories_WorkoutCalories_WorkoutCaloriesWorkoutID",
                table: "Calories");

            migrationBuilder.DropIndex(
                name: "IX_Calories_MealID",
                table: "Calories");

            migrationBuilder.DropIndex(
                name: "IX_Calories_StepsID",
                table: "Calories");

            migrationBuilder.DropIndex(
                name: "IX_Calories_WorkoutCaloriesWorkoutID",
                table: "Calories");

            migrationBuilder.DropColumn(
                name: "MealID",
                table: "Calories");

            migrationBuilder.DropColumn(
                name: "StepsID",
                table: "Calories");

            migrationBuilder.DropColumn(
                name: "WorkoutCaloriesWorkoutID",
                table: "Calories");

            migrationBuilder.AlterColumn<DateTime>(
                name: "EndDate",
                table: "Workouts",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<DateTime>(
                name: "EndDate",
                table: "Workouts",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone",
                oldNullable: true);

            migrationBuilder.AddColumn<int>(
                name: "MealID",
                table: "Calories",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "StepsID",
                table: "Calories",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "WorkoutCaloriesWorkoutID",
                table: "Calories",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Calories_MealID",
                table: "Calories",
                column: "MealID");

            migrationBuilder.CreateIndex(
                name: "IX_Calories_StepsID",
                table: "Calories",
                column: "StepsID");

            migrationBuilder.CreateIndex(
                name: "IX_Calories_WorkoutCaloriesWorkoutID",
                table: "Calories",
                column: "WorkoutCaloriesWorkoutID");

            migrationBuilder.AddForeignKey(
                name: "FK_Calories_Meals_MealID",
                table: "Calories",
                column: "MealID",
                principalTable: "Meals",
                principalColumn: "MealID");

            migrationBuilder.AddForeignKey(
                name: "FK_Calories_Steps_StepsID",
                table: "Calories",
                column: "StepsID",
                principalTable: "Steps",
                principalColumn: "StepsID");

            migrationBuilder.AddForeignKey(
                name: "FK_Calories_WorkoutCalories_WorkoutCaloriesWorkoutID",
                table: "Calories",
                column: "WorkoutCaloriesWorkoutID",
                principalTable: "WorkoutCalories",
                principalColumn: "WorkoutID");
        }
    }
}
