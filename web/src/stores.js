import { writable } from 'svelte/store';

export const cards = writable([]);
export const nextId = writable(1);
