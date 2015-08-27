package Utils;

// ================================================================
// Copyright (c) 2013-2014 Bluespec, Inc. All Rights Reserved.

// Misc. useful definitions, not app-specific

// ================================================================

import GetPut       :: *;
import ClientServer :: *;

// ================================================================

typeclass ToClient #(type req_t, type rsp_t, type ifc1_t, type ifc2_t);
   function Client #(req_t, rsp_t) toClient (ifc1_t  ifc1, ifc2_t  ifc2);
endtypeclass

typeclass ToServer #(type req_t, type rsp_t, type ifc1_t, type ifc2_t);
   function Server #(req_t, rsp_t) toServer (ifc1_t  ifc1, ifc2_t  ifc2);
endtypeclass

// ----------------

instance ToClient #(req_t, rsp_t, ifc1_t, ifc2_t)
   provisos (ToGet #(ifc1_t, req_t), ToPut #(ifc2_t, rsp_t));
   function Client #(req_t, rsp_t) toClient (ifc1_t ifc1, ifc2_t ifc2);
      return interface Client;
		interface Get request  = toGet (ifc1);
		interface Put response = toPut (ifc2);
	     endinterface;
   endfunction
endinstance

instance ToServer #(req_t, rsp_t, ifc1_t, ifc2_t)
   provisos (ToPut #(ifc1_t, req_t), ToGet #(ifc2_t, rsp_t));
   function Server #(req_t, rsp_t) toServer (ifc1_t ifc1, ifc2_t ifc2);
      return interface Server;
		interface Put request  = toPut (ifc1);
		interface Get response = toGet (ifc2);
	     endinterface;
   endfunction
endinstance

// ================================================================
// A convenience function to return the current cycle number during Bluesim simulations

ActionValue #(Bit #(32)) cur_cycle = actionvalue
					Bit #(32) t <- $stime;
					return t / 10;
				     endactionvalue;

// ================================================================

endpackage
