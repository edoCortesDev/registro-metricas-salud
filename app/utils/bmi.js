export function calculateBMI(weightKg, heightCm) {
  if (!heightCm || heightCm <= 0 || !weightKg || weightKg <= 0) return null;
  const heightM = heightCm / 100;
  return weightKg / (heightM * heightM);
}

export function getBMICategory(bmi) {
  if (bmi === null || bmi === undefined) return null;
  if (bmi < 18.5) return 'underweight';
  if (bmi < 25) return 'normal';
  if (bmi < 30) return 'overweight';
  return 'obese';
}
