# Mutant

1. Label node
2. Apply deployment with `maxSkew whenUnsatisfiable: DoNotSchedule` (hard constraint).
    One possible scheduling
    - pod-1 in node-1
    - pod-2 in node-2
    - pod-3 in node-3
3. Drain kind-worker
4. Pod-1 which was scheduled in node-1 will be evicted and remain `pending`.
    - nothing in node-1
    - pod-2 in node-2
    - pod-3 in node-3
    - pod-1 is in pending queue.
5. To relax pod spread constraint, change maxSkew to `whenUnsatisfiable: ScheduleAnyway` (soft constratin).
6. Something really weird happens. What we expect is pod-1 in pending queue is scheduled in node-2 (or node-3).
    - Expectation
        - nothing in node-1
        - pod-1, pod-2 in node-2
        - pod-3 in node-3
    - What actually happens
        - Log needs to be parsed.
