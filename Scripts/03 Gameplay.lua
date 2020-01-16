-- GameplayMargins exists to provide a layer of backwards compatibility for
-- people using the X position metrics to set where the notefields are.
-- This makes it somewhat complex.
-- Rather than trying to understand how it works, you can simply do this:
-- (example values in parentheses)
-- 1.  Decide how much space you want in the center between notefields. (80)
-- 2.  Decide how much space you want on each side. (40)
-- 3.  Write a simple function that just returns those numbers:
--     function GameplayMargins() return 40, 80, 40 end
-- Then the engine does the work of figuring out where each notefield should
-- be centered.
function GameplayMargins(enabled_players, styletype)
	return 8, 170, 8
end


function pillTransform(self,offsetFromCenter,itemIndex,numItems)
	local spacing_x=17;
	--self:zoomtoheight(20);
	self:x(-215+itemIndex*spacing_x);
	--self:x(0);
	self:zoomtowidth(46/1.5);
	self:rotationz(-90);
	self:MaskSource();
end;
