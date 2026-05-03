export function sanitizeText(input) {
  if (typeof input !== 'string') return String(input ?? '');
  const div = document.createElement('div');
  div.textContent = input;
  return div.textContent;
}

export function sanitizeNumber(input, { min = -Infinity, max = Infinity } = {}) {
  const n = parseFloat(input);
  if (isNaN(n) || n < min || n > max) return null;
  return n;
}
