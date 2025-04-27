public static class DateTimeExtensions
{
    public static DateTime? ToLocalTimeSafe(this DateTime? dateTime)
    {
        if (!dateTime.HasValue) return null;

        return dateTime.Value.Kind == DateTimeKind.Local
            ? dateTime.Value
            : dateTime.Value.ToLocalTime();
    }
}