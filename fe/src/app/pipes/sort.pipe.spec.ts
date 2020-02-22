import { ArraySortPipe } from './sort.pipe';

describe('SortPipe', () => {
  it('create an instance', () => {
    const pipe = new ArraySortPipe();
    expect(pipe).toBeTruthy();
  });
});
