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

#include "../SolverFactory.h"
#include "../options/SingleValueOption.h"

namespace solver {

class AspFactory : public SolverFactory
{
public:
	AspFactory(Application& app, bool newDefault = false);

	virtual std::unique_ptr<Solver> newSolver(const Decomposition& decomposition) const override;

	virtual void select() override;

private:
	static const std::string OPTION_SECTION;

	options::SingleValueOption optEncodingFile;
	options::Option            optDefaultJoin;
	options::Option            optTables;
};

} // namespace solver
