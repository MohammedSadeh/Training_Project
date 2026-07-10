  package arbitration_pkg;
    typedef struct packed {
      logic [8-1:0] id;
      logic [8-1:0] addr;
      logic [8-1:0] data;
    } request_t;
  endpackage
