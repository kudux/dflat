/*
Copyright 2012-2013, Bernhard Bliem
WWW: <http://dbai.tuwien.ac.at/research/project/dflat/>.

This file is part of D-FLAT.

D-FLAT is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

D-FLAT is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with D-FLAT.  If not, see <http://www.gnu.org/licenses/>.
*/

#pragma once

#include "../GringoOutputProcessor.h"

namespace solver { namespace asp { namespace tables {

class GringoOutputProcessor : public ::solver::asp::GringoOutputProcessor
{
public:
	struct ExtendAtomArguments {
		unsigned int childId;
		unsigned int rowNumber;
	};
	typedef AtomInfo<ExtendAtomArguments> ExtendAtomInfo;

	struct ItemAtomArguments {
		std::string item;
	};
	typedef AtomInfo<ItemAtomArguments> ItemAtomInfo;

	struct CountAtomArguments {
		unsigned int count; // XXX better use mpz_class
	};
	typedef AtomInfo<CountAtomArguments> CountAtomInfo;

	struct CurrentCostAtomArguments {
		long currentCost;
	};
	typedef AtomInfo<CurrentCostAtomArguments> CurrentCostAtomInfo;

	struct CostAtomArguments {
		long cost;
	};
	typedef AtomInfo<CostAtomArguments> CostAtomInfo;

	typedef std::vector<ItemAtomInfo>        ItemAtomInfos;
	typedef std::vector<ExtendAtomInfo>      ExtendAtomInfos;
	typedef std::vector<CountAtomInfo>       CountAtomInfos;
	typedef std::vector<CurrentCostAtomInfo> CurrentCostAtomInfos;
	typedef std::vector<CostAtomInfo>        CostAtomInfos;

	GringoOutputProcessor();

	const ItemAtomInfos&        getItemAtomInfos()        const;
	const ExtendAtomInfos&      getExtendAtomInfos()      const;
	const CountAtomInfos&       getCountAtomInfos()       const;
	const CurrentCostAtomInfos& getCurrentCostAtomInfos() const;
	const CostAtomInfos&        getCostAtomInfos()        const;

protected:
	virtual void storeAtom(const std::string& name, ValVec::const_iterator firstArg, uint32_t arity, Clasp::SymbolTable::key_type symbolTableKey);

	ItemAtomInfos        itemAtomInfos;
	ExtendAtomInfos      extendAtomInfos;
	CountAtomInfos       countAtomInfos;
	CurrentCostAtomInfos currentCostAtomInfos;
	CostAtomInfos        costAtomInfos;
};

}}} // namespace solver::asp::tables
