declare module 'lodash/debounce' {
  /**
   * A lightweight type for lodash debounce's default export.
   * It keeps the call signature and the cancel/flush helpers used by most apps.
   */
  function debounce<T extends (...args: any[]) => any>(
    func: T,
    wait?: number,
    options?: { leading?: boolean; maxWait?: number; trailing?: boolean }
  ): T & { cancel(): void; flush(): void };

  export default debounce;
}

