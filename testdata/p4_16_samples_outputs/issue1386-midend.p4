#include <core.p4>
#include <v1model.p4>

header hdr {
    bit<32> a;
}

struct Headers {
    hdr h;
}

struct Meta {
}

parser p(packet_in b, out Headers h, inout Meta m, inout standard_metadata_t sm) {
    state start {
        b.extract<hdr>(h.h);
        transition accept;
    }
}

control vrfy(inout Headers h, inout Meta m) {
    apply {
    }
}

control update(inout Headers h, inout Meta m) {
    apply {
    }
}

control egress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}

control deparser(packet_out b, in Headers h) {
    apply {
        b.emit<hdr>(h.h);
    }
}

control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    bool c_hasReturned;
    @hidden action act() {
        c_hasReturned = true;
    }
    @hidden action act_0() {
        c_hasReturned = false;
    }
    @hidden action act_1() {
        sm.egress_spec = 9w0;
    }
    @hidden table tbl_act {
        actions = {
            act_0();
        }
        const default_action = act_0();
    }
    @hidden table tbl_act_0 {
        actions = {
            act();
        }
        const default_action = act();
    }
    @hidden table tbl_act_1 {
        actions = {
            act_1();
        }
        const default_action = act_1();
    }
    apply {
        tbl_act.apply();
        if (!h.h.isValid()) {
            tbl_act_0.apply();
        }
        tbl_act_1.apply();
    }
}

V1Switch<Headers, Meta>(p(), vrfy(), ingress(), egress(), update(), deparser()) main;

