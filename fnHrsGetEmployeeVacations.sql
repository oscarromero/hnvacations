CREATE FUNCTION fnHrsGetEmployeeVacations (@dtStartDate DATETIME, @dtEndDate DATETIME) RETURNS INT AS
BEGIN
	DECLARE @dcYearsAndDays DECIMAL(12,4)
	DECLARE @inYears        INT
	DECLARE @inVacations    INT

	DECLARE @inCurrentYearScale INT
	DECLARE @inAccumulativeYearScale INT
	DECLARE @dcBaseNumber DECIMAL(12,4)
	DECLARE @dcDaysForCurrentYear DECIMAL(12,4)

	IF ISNULL(@dtEndDate,0) = 0 BEGIN
		SET @dtEndDate = GETDATE()
	END

	SET @dcYearsAndDays = ROUND(ABS(DATEDIFF(DAY,@dtEndDate,@dtStartDate)) / 365.0000, 4)
	SET @inYears        = ROUND(@dcYearsAndDays,0)
	IF @inYears <= 0 BEGIN
		SET @inYears = 1
	END

	SET @inCurrentYearScale = CASE @inYears
		WHEN 0 THEN 10
		WHEN 1 THEN 10
		WHEN 2 THEN 12
		WHEN 3 THEN 15
		WHEN 4 THEN 20
		ELSE 20
	END

	SET @inAccumulativeYearScale = CASE @inYears
		WHEN 0 THEN 10
		WHEN 1 THEN 10
		WHEN 2 THEN 10
		WHEN 3 THEN 22
		WHEN 4 THEN 37
		ELSE 57 + ((@inYears - 4) * 20)
	END

	SET @dcBaseNumber = @dcYearsAndDays - (CASE @inYears WHEN 1 THEN 1 ELSE (@inYears - 1) END)
	SET @dcDaysForCurrentYear = @dcBaseNumber * @inCurrentYearScale
	SET @inVacations = @dcDaysForCurrentYear + @inAccumulativeYearScale
		
	RETURN @inVacations
END
