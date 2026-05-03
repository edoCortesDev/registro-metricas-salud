const state = {
  user: null,
  profile: null,
  metrics: [],
  theme: 'auto',
  language: 'es',
};

const listeners = {};

export function getState(key) {
  return state[key];
}

export function setState(key, value) {
  state[key] = value;
  (listeners[key] || []).forEach(fn => fn(value));
}

export function subscribe(key, fn) {
  if (!listeners[key]) listeners[key] = [];
  listeners[key].push(fn);
  return function unsubscribe() {
    listeners[key] = listeners[key].filter(f => f !== fn);
  };
}

export function resetState() {
  state.user = null;
  state.profile = null;
  state.metrics = [];
}
